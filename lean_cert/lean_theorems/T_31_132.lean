import Sound
import lean_certs.cert_31_132

open CertVerify

theorem H31_gt_132 : ¬ ∃ t : List Nat, admissible 31 t = true ∧ diameter t ≤ 132 := by
  exact certValidRoot_sound (k := 31) (d := 132) (c := cert_31_132) (by native_decide)
