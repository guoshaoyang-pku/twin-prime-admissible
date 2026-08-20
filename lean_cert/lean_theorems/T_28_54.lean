import Sound
import lean_certs.cert_28_54

open CertVerify

theorem H28_gt_54 : ¬ ∃ t : List Nat, admissible 28 t = true ∧ diameter t ≤ 54 := by
  exact certValidRoot_sound (k := 28) (d := 54) (c := cert_28_54) (by native_decide)
