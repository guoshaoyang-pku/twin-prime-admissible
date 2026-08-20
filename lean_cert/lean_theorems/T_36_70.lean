import Sound
import lean_certs.cert_36_70

open CertVerify

theorem H36_gt_70 : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 70 := by
  exact certValidRoot_sound (k := 36) (d := 70) (c := cert_36_70) (by native_decide)
