import Sound
import lean_certs.cert_21_50

open CertVerify

theorem H21_gt_50 : ¬ ∃ t : List Nat, admissible 21 t = true ∧ diameter t ≤ 50 := by
  exact certValidRoot_sound (k := 21) (d := 50) (c := cert_21_50) (by native_decide)
