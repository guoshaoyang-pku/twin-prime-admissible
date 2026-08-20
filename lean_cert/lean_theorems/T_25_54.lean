import Sound
import lean_certs.cert_25_54

open CertVerify

theorem H25_gt_54 : ¬ ∃ t : List Nat, admissible 25 t = true ∧ diameter t ≤ 54 := by
  exact certValidRoot_sound (k := 25) (d := 54) (c := cert_25_54) (by native_decide)
