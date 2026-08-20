import Sound
import lean_certs.cert_39_102

open CertVerify

theorem H39_gt_102 : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 102 := by
  exact certValidRoot_sound (k := 39) (d := 102) (c := cert_39_102) (by native_decide)
