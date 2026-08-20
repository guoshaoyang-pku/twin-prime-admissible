import Sound
import lean_certs.cert_37_102

open CertVerify

theorem H37_gt_102 : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 102 := by
  exact certValidRoot_sound (k := 37) (d := 102) (c := cert_37_102) (by native_decide)
