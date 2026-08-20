import Sound
import lean_certs.cert_21_64

open CertVerify

theorem H21_gt_64 : ¬ ∃ t : List Nat, admissible 21 t = true ∧ diameter t ≤ 64 := by
  exact certValidRoot_sound (k := 21) (d := 64) (c := cert_21_64) (by native_decide)
