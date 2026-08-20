import Sound
import lean_certs.cert_24_54

open CertVerify

theorem H24_gt_54 : ¬ ∃ t : List Nat, admissible 24 t = true ∧ diameter t ≤ 54 := by
  exact certValidRoot_sound (k := 24) (d := 54) (c := cert_24_54) (by native_decide)
