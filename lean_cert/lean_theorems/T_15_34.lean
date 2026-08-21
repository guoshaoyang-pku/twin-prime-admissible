import Sound
import lean_certs.cert_15_34

open CertVerify

theorem H15_gt_34 : ¬ ∃ t : List Nat, admissible 15 t = true ∧ diameter t ≤ 34 := by
  exact certValidRoot_sound (k := 15) (d := 34) (c := cert_15_34) (by native_decide)
