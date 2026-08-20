import Sound
import lean_certs.cert_41_108

open CertVerify

theorem H41_gt_108 : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 108 := by
  exact certValidRoot_sound (k := 41) (d := 108) (c := cert_41_108) (by native_decide)
