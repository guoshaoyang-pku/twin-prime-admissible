import Sound
import lean_certs.cert_23_54

open CertVerify

theorem H23_gt_54 : ¬ ∃ t : List Nat, admissible 23 t = true ∧ diameter t ≤ 54 := by
  exact certValidRoot_sound (k := 23) (d := 54) (c := cert_23_54) (by native_decide)
