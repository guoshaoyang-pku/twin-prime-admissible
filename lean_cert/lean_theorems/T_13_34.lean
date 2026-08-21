import Sound
import lean_certs.cert_13_34

open CertVerify

theorem H13_gt_34 : ¬ ∃ t : List Nat, admissible 13 t = true ∧ diameter t ≤ 34 := by
  exact certValidRoot_sound (k := 13) (d := 34) (c := cert_13_34) (by native_decide)
