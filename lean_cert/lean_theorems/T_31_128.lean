import Sound
import lean_certs.cert_31_128

open CertVerify

theorem H31_gt_128 : ¬ ∃ t : List Nat, admissible 31 t = true ∧ diameter t ≤ 128 := by
  exact certValidRoot_sound (k := 31) (d := 128) (c := cert_31_128) (by native_decide)
