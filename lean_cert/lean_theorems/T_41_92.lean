import Sound
import lean_certs.cert_41_92

open CertVerify

theorem H41_gt_92 : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 92 := by
  exact certValidRoot_sound (k := 41) (d := 92) (c := cert_41_92) (by native_decide)
