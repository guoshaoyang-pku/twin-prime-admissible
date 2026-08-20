import Sound
import lean_certs.cert_25_50

open CertVerify

theorem H25_gt_50 : ¬ ∃ t : List Nat, admissible 25 t = true ∧ diameter t ≤ 50 := by
  exact certValidRoot_sound (k := 25) (d := 50) (c := cert_25_50) (by native_decide)
