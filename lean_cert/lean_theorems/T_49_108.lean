import Sound
import lean_certs.cert_49_108

open CertVerify

theorem H49_gt_108 : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 108 := by
  exact certValidRoot_sound (k := 49) (d := 108) (c := cert_49_108) (by native_decide)
