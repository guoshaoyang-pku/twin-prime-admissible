import Sound
import lean_certs.cert_31_62

open CertVerify

theorem H31_gt_62 : ¬ ∃ t : List Nat, admissible 31 t = true ∧ diameter t ≤ 62 := by
  exact certValidRoot_sound (k := 31) (d := 62) (c := cert_31_62) (by native_decide)
