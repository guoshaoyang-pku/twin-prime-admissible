import Sound
import lean_certs.cert_22_64

open CertVerify

theorem H22_gt_64 : ¬ ∃ t : List Nat, admissible 22 t = true ∧ diameter t ≤ 64 := by
  exact certValidRoot_sound (k := 22) (d := 64) (c := cert_22_64) (by native_decide)
