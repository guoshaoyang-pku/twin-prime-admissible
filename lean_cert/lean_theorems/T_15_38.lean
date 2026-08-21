import Sound
import lean_certs.cert_15_38

open CertVerify

theorem H15_gt_38 : ¬ ∃ t : List Nat, admissible 15 t = true ∧ diameter t ≤ 38 := by
  exact certValidRoot_sound (k := 15) (d := 38) (c := cert_15_38) (by native_decide)
