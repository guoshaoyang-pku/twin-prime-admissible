import Sound
import lean_certs.cert_22_50

open CertVerify

theorem H22_gt_50 : ¬ ∃ t : List Nat, admissible 22 t = true ∧ diameter t ≤ 50 := by
  exact certValidRoot_sound (k := 22) (d := 50) (c := cert_22_50) (by native_decide)
