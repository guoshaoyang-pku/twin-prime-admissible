import Sound
import lean_certs.cert_30_92

open CertVerify

theorem H30_gt_92 : ¬ ∃ t : List Nat, admissible 30 t = true ∧ diameter t ≤ 92 := by
  exact certValidRoot_sound (k := 30) (d := 92) (c := cert_30_92) (by native_decide)
