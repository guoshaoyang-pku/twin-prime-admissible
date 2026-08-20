import Sound
import lean_certs.cert_36_122

open CertVerify

theorem H36_gt_122 : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 122 := by
  exact certValidRoot_sound (k := 36) (d := 122) (c := cert_36_122) (by native_decide)
