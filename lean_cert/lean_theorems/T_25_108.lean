import Sound
import lean_certs.cert_25_108

open CertVerify

theorem H25_gt_108 : ¬ ∃ t : List Nat, admissible 25 t = true ∧ diameter t ≤ 108 := by
  exact certValidRoot_sound (k := 25) (d := 108) (c := cert_25_108) (by native_decide)
