import Sound
import lean_certs.cert_21_80

open CertVerify

theorem H21_gt_80 : ¬ ∃ t : List Nat, admissible 21 t = true ∧ diameter t ≤ 80 := by
  exact certValidRoot_sound (k := 21) (d := 80) (c := cert_21_80) (by native_decide)
