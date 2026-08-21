import Sound
import lean_certs.cert_14_32

open CertVerify

theorem H14_gt_32 : ¬ ∃ t : List Nat, admissible 14 t = true ∧ diameter t ≤ 32 := by
  exact certValidRoot_sound (k := 14) (d := 32) (c := cert_14_32) (by native_decide)
