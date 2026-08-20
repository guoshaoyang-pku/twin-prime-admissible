import Sound
import lean_certs.cert_31_64

open CertVerify

theorem H31_gt_64 : ¬ ∃ t : List Nat, admissible 31 t = true ∧ diameter t ≤ 64 := by
  exact certValidRoot_sound (k := 31) (d := 64) (c := cert_31_64) (by native_decide)
