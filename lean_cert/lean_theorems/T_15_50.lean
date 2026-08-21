import Sound
import lean_certs.cert_15_50

open CertVerify

theorem H15_gt_50 : ¬ ∃ t : List Nat, admissible 15 t = true ∧ diameter t ≤ 50 := by
  exact certValidRoot_sound (k := 15) (d := 50) (c := cert_15_50) (by native_decide)
