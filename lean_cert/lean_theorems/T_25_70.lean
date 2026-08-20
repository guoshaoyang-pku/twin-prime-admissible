import Sound
import lean_certs.cert_25_70

open CertVerify

theorem H25_gt_70 : ¬ ∃ t : List Nat, admissible 25 t = true ∧ diameter t ≤ 70 := by
  exact certValidRoot_sound (k := 25) (d := 70) (c := cert_25_70) (by native_decide)
