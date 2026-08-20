import Sound
import lean_certs.cert_25_66

open CertVerify

theorem H25_gt_66 : ¬ ∃ t : List Nat, admissible 25 t = true ∧ diameter t ≤ 66 := by
  exact certValidRoot_sound (k := 25) (d := 66) (c := cert_25_66) (by native_decide)
