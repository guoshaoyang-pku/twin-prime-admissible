import Sound
import lean_certs.cert_31_70

open CertVerify

theorem H31_gt_70 : ¬ ∃ t : List Nat, admissible 31 t = true ∧ diameter t ≤ 70 := by
  exact certValidRoot_sound (k := 31) (d := 70) (c := cert_31_70) (by native_decide)
