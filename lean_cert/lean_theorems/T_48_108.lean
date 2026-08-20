import Sound
import lean_certs.cert_48_108

open CertVerify

theorem H48_gt_108 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 108 := by
  exact certValidRoot_sound (k := 48) (d := 108) (c := cert_48_108) (by native_decide)
