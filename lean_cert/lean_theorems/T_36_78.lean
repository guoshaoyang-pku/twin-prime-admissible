import Sound
import lean_certs.cert_36_78

open CertVerify

theorem H36_gt_78 : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 78 := by
  exact certValidRoot_sound (k := 36) (d := 78) (c := cert_36_78) (by native_decide)
