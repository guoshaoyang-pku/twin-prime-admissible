import Sound
import lean_certs.cert_18_42

open CertVerify

theorem H18_gt_42 : ¬ ∃ t : List Nat, admissible 18 t = true ∧ diameter t ≤ 42 := by
  exact certValidRoot_sound (k := 18) (d := 42) (c := cert_18_42) (by native_decide)
