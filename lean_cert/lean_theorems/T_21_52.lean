import Sound
import lean_certs.cert_21_52

open CertVerify

theorem H21_gt_52 : ¬ ∃ t : List Nat, admissible 21 t = true ∧ diameter t ≤ 52 := by
  exact certValidRoot_sound (k := 21) (d := 52) (c := cert_21_52) (by native_decide)
