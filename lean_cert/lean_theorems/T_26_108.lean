import Sound
import lean_certs.cert_26_108

open CertVerify

theorem H26_gt_108 : ¬ ∃ t : List Nat, admissible 26 t = true ∧ diameter t ≤ 108 := by
  exact certValidRoot_sound (k := 26) (d := 108) (c := cert_26_108) (by native_decide)
