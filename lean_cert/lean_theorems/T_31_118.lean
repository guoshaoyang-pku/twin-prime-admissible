import Sound
import lean_certs.cert_31_118

open CertVerify

theorem H31_gt_118 : ¬ ∃ t : List Nat, admissible 31 t = true ∧ diameter t ≤ 118 := by
  exact certValidRoot_sound (k := 31) (d := 118) (c := cert_31_118) (by native_decide)
