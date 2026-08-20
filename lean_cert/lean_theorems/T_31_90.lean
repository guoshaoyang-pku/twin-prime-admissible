import Sound
import lean_certs.cert_31_90

open CertVerify

theorem H31_gt_90 : ¬ ∃ t : List Nat, admissible 31 t = true ∧ diameter t ≤ 90 := by
  exact certValidRoot_sound (k := 31) (d := 90) (c := cert_31_90) (by native_decide)
