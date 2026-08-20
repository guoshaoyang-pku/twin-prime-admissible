import Sound
import lean_certs.cert_24_70

open CertVerify

theorem H24_gt_70 : ¬ ∃ t : List Nat, admissible 24 t = true ∧ diameter t ≤ 70 := by
  exact certValidRoot_sound (k := 24) (d := 70) (c := cert_24_70) (by native_decide)
