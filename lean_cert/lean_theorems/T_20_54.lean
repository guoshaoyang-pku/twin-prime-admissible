import Sound
import lean_certs.cert_20_54

open CertVerify

theorem H20_gt_54 : ¬ ∃ t : List Nat, admissible 20 t = true ∧ diameter t ≤ 54 := by
  exact certValidRoot_sound (k := 20) (d := 54) (c := cert_20_54) (by native_decide)
