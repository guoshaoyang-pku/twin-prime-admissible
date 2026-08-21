import Sound
import lean_certs.cert_13_46

open CertVerify

theorem H13_gt_46 : ¬ ∃ t : List Nat, admissible 13 t = true ∧ diameter t ≤ 46 := by
  exact certValidRoot_sound (k := 13) (d := 46) (c := cert_13_46) (by native_decide)
