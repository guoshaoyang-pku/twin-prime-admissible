import Sound
import lean_certs.cert_39_108

open CertVerify

theorem H39_gt_108 : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 108 := by
  exact certValidRoot_sound (k := 39) (d := 108) (c := cert_39_108) (by native_decide)
