import Sound
import lean_certs.cert_36_102

open CertVerify

theorem H36_gt_102 : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 102 := by
  exact certValidRoot_sound (k := 36) (d := 102) (c := cert_36_102) (by native_decide)
