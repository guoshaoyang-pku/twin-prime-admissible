import Sound
import lean_certs.cert_22_80

open CertVerify

theorem H22_gt_80 : ¬ ∃ t : List Nat, admissible 22 t = true ∧ diameter t ≤ 80 := by
  exact certValidRoot_sound (k := 22) (d := 80) (c := cert_22_80) (by native_decide)
