import Sound
import lean_certs.cert_24_92

open CertVerify

theorem H24_gt_92 : ¬ ∃ t : List Nat, admissible 24 t = true ∧ diameter t ≤ 92 := by
  exact certValidRoot_sound (k := 24) (d := 92) (c := cert_24_92) (by native_decide)
