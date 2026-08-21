import Sound
import lean_certs.cert_17_54

open CertVerify

theorem H17_gt_54 : ¬ ∃ t : List Nat, admissible 17 t = true ∧ diameter t ≤ 54 := by
  exact certValidRoot_sound (k := 17) (d := 54) (c := cert_17_54) (by native_decide)
