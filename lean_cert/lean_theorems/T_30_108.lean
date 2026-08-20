import Sound
import lean_certs.cert_30_108

open CertVerify

theorem H30_gt_108 : ¬ ∃ t : List Nat, admissible 30 t = true ∧ diameter t ≤ 108 := by
  exact certValidRoot_sound (k := 30) (d := 108) (c := cert_30_108) (by native_decide)
