import Sound
import lean_certs.cert_31_72

open CertVerify

theorem H31_gt_72 : ¬ ∃ t : List Nat, admissible 31 t = true ∧ diameter t ≤ 72 := by
  exact certValidRoot_sound (k := 31) (d := 72) (c := cert_31_72) (by native_decide)
