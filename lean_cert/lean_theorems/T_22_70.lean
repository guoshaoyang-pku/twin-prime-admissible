import Sound
import lean_certs.cert_22_70

open CertVerify

theorem H22_gt_70 : ¬ ∃ t : List Nat, admissible 22 t = true ∧ diameter t ≤ 70 := by
  exact certValidRoot_sound (k := 22) (d := 70) (c := cert_22_70) (by native_decide)
