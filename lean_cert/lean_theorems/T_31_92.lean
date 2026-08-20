import Sound
import lean_certs.cert_31_92

open CertVerify

theorem H31_gt_92 : ¬ ∃ t : List Nat, admissible 31 t = true ∧ diameter t ≤ 92 := by
  exact certValidRoot_sound (k := 31) (d := 92) (c := cert_31_92) (by native_decide)
