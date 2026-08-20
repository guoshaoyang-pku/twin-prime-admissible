import Sound
import lean_certs.cert_20_50

open CertVerify

theorem H20_gt_50 : ¬ ∃ t : List Nat, admissible 20 t = true ∧ diameter t ≤ 50 := by
  exact certValidRoot_sound (k := 20) (d := 50) (c := cert_20_50) (by native_decide)
