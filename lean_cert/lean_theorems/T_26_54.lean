import Sound
import lean_certs.cert_26_54

open CertVerify

theorem H26_gt_54 : ¬ ∃ t : List Nat, admissible 26 t = true ∧ diameter t ≤ 54 := by
  exact certValidRoot_sound (k := 26) (d := 54) (c := cert_26_54) (by native_decide)
