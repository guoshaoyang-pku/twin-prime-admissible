import Sound
import lean_certs.cert_15_46

open CertVerify

theorem H15_gt_46 : ¬ ∃ t : List Nat, admissible 15 t = true ∧ diameter t ≤ 46 := by
  exact certValidRoot_sound (k := 15) (d := 46) (c := cert_15_46) (by native_decide)
