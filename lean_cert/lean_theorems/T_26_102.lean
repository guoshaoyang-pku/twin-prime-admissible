import Sound
import lean_certs.cert_26_102

open CertVerify

theorem H26_gt_102 : ¬ ∃ t : List Nat, admissible 26 t = true ∧ diameter t ≤ 102 := by
  exact certValidRoot_sound (k := 26) (d := 102) (c := cert_26_102) (by native_decide)
