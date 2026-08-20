import Sound
import lean_certs.cert_20_66

open CertVerify

theorem H20_gt_66 : ¬ ∃ t : List Nat, admissible 20 t = true ∧ diameter t ≤ 66 := by
  exact certValidRoot_sound (k := 20) (d := 66) (c := cert_20_66) (by native_decide)
