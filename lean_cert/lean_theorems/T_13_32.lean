import Sound
import lean_certs.cert_13_32

open CertVerify

theorem H13_gt_32 : ¬ ∃ t : List Nat, admissible 13 t = true ∧ diameter t ≤ 32 := by
  exact certValidRoot_sound (k := 13) (d := 32) (c := cert_13_32) (by native_decide)
